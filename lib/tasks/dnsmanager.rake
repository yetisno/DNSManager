namespace :dnsmgr do
	namespace :db do
		desc 'DNSManager | Rebuild DB'
		task rebuild: :environment do
			Rake::Task['dnsmgr:db:drop'].invoke
			Rake::Task['dnsmgr:db:init'].invoke
		end
		desc 'DNSManager | Build DB'
		task init: :environment do
			Rake::Task['db:migrate'].invoke
			Rake::Task['db:seed'].invoke
		end
		desc 'DNSManager | Drop DB'
		task drop: :environment do
			Rake::Task['db:drop'].invoke
		end
	end
end
