target "debian-12" {
  context = "images/debian-12"
  dockerfile = "Containerfile"
}

# NOTE: This build is heavily docker-specific and requires
#       builders configured with the "insecure" flag.
target "raspbian-12" {
  context = "images/raspbian-12"
  dockerfile = "Dockerfile"
  entitlements = ["security.insecure"]
}
