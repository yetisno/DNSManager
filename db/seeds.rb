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
Domain.create(name: 'example.com', description: 'example site').save!
Soa.create(domain_id: 1, name: 'example.com', contact: 'admin.example.com', serial: 12312311, refresh: 120, retry: 120, expire: 86400, minimum: 120).save!
Nameserver.create(domain_id: 1, name: 'example.com', to_ns: 'ns1.example.com').save!
Nameserver.create(domain_id: 1, name: 'example.com', to_ns: 'ns2.example.com').save!
A.create(domain_id: 1, name: 'www.example.com', to_ip: '127.0.0.1').save!
Cname.create(domain_id: 1, name: 'www2.example.com', to_name: 'www.example.com').save!
Mx.create(domain_id: 1, name: 'example.com', priority: 1, to_name: 'mx.example.com').save!
Mx.create(domain_id: 1, name: 'example.com', priority: 5, to_name: 'mx2.example.com').save!
Ptr.create(domain_id: 1, ip_arpa: '1.0.0.127.in-addr.arpa', to_name: 'www.example.com').save!