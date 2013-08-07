class Commands
  attr_accessor :pwd, :branch

  def create
    cd_into_target
    system %{git clone git@bitbucket.org:movielalainc/web.git --branch #{branch} --single-branch #{pwd}}
    link_db_config
  end

  def update
    cd_into_target
    system %{git pull origin #{branch}}
  end

  def cd_into_target
    system %{mkdir -p #{pwd}}
    system %{cd #{pwd}}
  end

  def link_db_config
    system %{ln -nfs #{shared_db_config} #{target_db_config}}
  end

  def self.fire(options)
    command = new
    command.pwd = options[:in]
    command.branch = options[:branch] if options[:branch]
    command.send(options[:run])
    command
  end

  private

  def shared_db_config
    '/var/www/vhosts/movielala/staging/shared/config/database.yml'
  end

  def target_db_config
    "#{pwd}/config/database.yml"
  end
end

