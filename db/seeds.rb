# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# User.create :id => 1, :email => 'yeti@yetiz.org', :encrypted_password => '$2a$10$81gaqKuyY3Vl2rclIF2T4e.cieaRsb.YvZ69ZiEvmktNfj8.r05ji',
#             :username => 'Yeti', :admin => '1'
User.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', username: 'admin', admin: true).save!
User.create(email: 'user@example.com', password: 'password', password_confirmation: 'password', username: 'user', admin: false).save!
Domain.create(name: 'example.com', description: 'example site').save!
Domain.create(name: 'abc.com', description: 'abc site').save!
Domain.create(name: 'xyz.com', description: 'xyz site').save!
UserDomainMap.create(user_id: 1, domain_id: 1).save!
UserDomainMap.create(user_id: 1, domain_id: 2).save!
UserDomainMap.create(user_id: 2, domain_id: 1).save!
UserDomainMap.create(user_id: 2, domain_id: 3).save!
Soa.create(domain_id: 1, name: 'example.com', contact: 'admin.example.com', serial: 12312311, refresh: 120, retry: 120, expire: 86400, minimum: 120).save!
Soa.create(domain_id: 2, name: 'abc.com', contact: 'admin.abc.com', serial: 12312312, refresh: 120, retry: 120, expire: 86401, minimum: 120).save!
Soa.create(domain_id: 3, name: 'xyz.com', contact: 'admin.xyz.com', serial: 12312313, refresh: 120, retry: 120, expire: 86402, minimum: 120).save!
Nameserver.create(domain_id: 1, name: 'example.com', to_ns: 'ns1.example.com').save!
Nameserver.create(domain_id: 1, name: 'example.com', to_ns: 'ns2.example.com').save!
A.create(domain_id: 1, name: 'www.example.com', to_ip: '127.0.0.1').save!
A.create(domain_id: 1, name: 'www.example.com', to_ip: '127.0.0.2').save!
Cname.create(domain_id: 1, name: 'www2.example.com', to_name: 'www.example.com').save!
Mx.create(domain_id: 1, name: 'example.com', priority: 1, to_name: 'mx.example.com').save!
Mx.create(domain_id: 1, name: 'example.com', priority: 5, to_name: 'mx2.example.com').save!
Ptr.create(domain_id: 1, ip_arpa: '1.0.0.127.in-addr.arpa', to_name: 'www.example.com').save!
