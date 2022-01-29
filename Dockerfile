FROM comtravo/terraform:test-workhorse-0.14.11-1.0.0

WORKDIR /go/src/github.com/comtravo/terraform-modules
COPY . .
