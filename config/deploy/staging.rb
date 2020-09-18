server "ec2-34-209-88-170.us-west-2.compute.amazonaws.com", user: 'ubuntu', roles: %w{web db}

set :rbenv_ruby, '2.6.5'

set :branch, 'staging'

set :ssh_options, {
    keys: [ENV['DGIDB_STAGING_KEY']],
    forward_agent: false,
    auth_methods: %w(publickey)
}