{
  lib,
  options,
  env,
  ...
}: let
  project =
    {
      dev = "exampleelm-dev-419007";
      prod = {};
    }
    .${env};

  domain =
    {
      dev = "cachet-jp.dev";
      prod = {};
    }
    .${env};
  # TODO: After the first apply, uncomment the following and specify the Cloud Storage bucket.
  # bucket =
  #   {
  #     dev = "xxxxxxxxxxxxxxxx-bucket-tfstate";
  #     prod = {};
  #   }
  #   .${env};
in {
  terraform.required_providers = {
    google.source = "hashicorp/google";
  };

  # TODO: After the first apply, uncomment the following to enable the backend using a Cloud Storage bucket.
  # terraform.backend.gcs = {
  #   inherit bucket;
  #   prefix = "terraform/state";
  # };

  provider.google-beta = {
    inherit project;
    region = "asia-northeast1";
    user_project_override = true;
  };

  module.project_services = {
    source = "terraform-google-modules/project-factory/google//modules/project_services";
    version = "~> 14.4";

    project_id = project;

    enable_apis = true;
    activate_apis = [
      "storage.googleapis.com"
      "artifactregistry.googleapis.com"
      "compute.googleapis.com"
      "run.googleapis.com"
    ];
    disable_services_on_destroy = false;
  };

  resource.random_id.bucket_prefix.byte_length = 8;

  resource.google_storage_bucket.default = {
    force_destroy = false;
    inherit project;
    location = "ASIA";
    name = ''${lib.tfRef "random_id.bucket_prefix.hex"}-bucket-tfstate'';
    storage_class = "STANDARD";
    versioning.enabled = true;
  };

  resource.google_artifact_registry_repository.repo = {
    inherit project;
    location = "asia-northeast1";
    repository_id = "container";
    format = "DOCKER";
  };

  resource.google_cloud_run_v2_service.default = {
    name = "cloudrun-service";
    location = "asia-northeast1";
    inherit project;

    template.containers = {
      image = "us-docker.pkg.dev/cloudrun/container/hello:latest";
    };

    lifecycle.ignore_changes = [
      "client"
      "client_version"
      "template[0].containers[0].image"
    ];
  };

  resource.google_cloud_run_service_iam_binding.default = {
    location = lib.tfRef "google_cloud_run_v2_service.default.location";
    inherit project;
    service = lib.tfRef "google_cloud_run_v2_service.default.name";
    role = "roles/run.invoker";
    members = ["allUsers"];
  };

  resource.google_cloud_run_domain_mapping = {
    exampleelm = {
      location = lib.tfRef "google_cloud_run_v2_service.default.location";
      inherit project;
      name = "exampleelm.${domain}";
      metadata.namespace = project;
      spec.route_name = lib.tfRef "google_cloud_run_v2_service.default.name";
    };
  };
}
