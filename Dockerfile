FROM comtravo/terraform:test-workhorse-1.1.4-1.0.0

WORKDIR /go/src/github.com/comtravo/terraform-modules
COPY . .
