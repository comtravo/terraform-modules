FROM puneethn/terraform-test-workhorse:0.13.7

WORKDIR /go/src/github.com/comtravo/terraform-modules
COPY . .
