GEM_NAME=auth0
SPEC_FILE=auth0.gemspec
REGION=us-east-1

gem build $SPEC_FILE

RUBY_PASSWD = $(aws secretsmanager get-secret-value --secret-id jenkins-ruby-deployer --region $REGION | jq .SecretString -r)

curl http://artifactory.devaws.dataxu.net/artifactory/api/gems/ruby-local/api/v1/api_key.yaml -u ruby-deployer:$RUBY_PASSWD > ~/.gem/credentials

gem push $GEM_NAME --host http://artifactory.devaws.dataxu.net/artifactory/api/gems/ruby-local/
