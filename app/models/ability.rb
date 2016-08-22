class Ability
  include CanCan::Ability

  def initialize(user)
    if user.is_admin?
      can(:manage, :all)
    else
      can :manage, EditUser, id: user.id
      can :manage, SystemUser, user_id: user.id
      can :manage, Apache, user_id: user.id
      can :manage, Vhost, apache: { user_id: user.id }
      can :manage, RailsServer, user_id: user.id
      can :manage, Domain, user_id: user.id
      can :manage, DnsRecord, domain: { user_id: user.id }
      can :read, EmailDomain, user_id: user.id
      can :manage, EmailUser, email_domain: { user_id: user.id }
      can :manage, EmailAlias, email_domain: { user_id: user.id }
      can :manage, Ftp, system_user: { user_id: user.id }
      can :create, MysqlUser
      can :manage, MysqlUser, apache: { user_id: user.id }
      can :manage, MysqlDb, mysql_user: { apache: { user_id: user.id } }
      can :create, PgsqlUser
      can :manage, PgsqlUser, apache: { user_id: user.id }
      can :manage, PgsqlDb, pgsql_user: { apache: { user_id: user.id } }
      cannot [:create, :destroy], [Apache, Domain, EditUser, SystemUser]

      # Validations will block the creation
      can :create, Ftp, system_user: nil
    end
  end
end
