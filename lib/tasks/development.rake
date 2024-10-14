# frozen_string_literal: true

namespace :development do
  desc 'Complete accession workflow for a work'
  task :accession, [:druid] => :environment do |_t, args|
    raise '*** Only works in development mode!' unless Rails.env.development?

    client = Dor::Workflow::Client.new(url: Settings.workflow.url)
    client.skip_all(druid: args[:druid], workflow: 'accessionWF', note: 'Testing')

    puts "Completed accessionWF for #{args[:druid]}"
  end

  desc 'Seed Scholarly article dataset collection'
  task seed_collection: :environment do |_t, _args|
    raise '*** Only works in development mode!' unless Rails.env.development?

    collection_title = 'Scholarly article dataset'

    return puts 'Collection already exists' if Collection.exists?(title: collection_title)

    request_collection = Cocina::Models.build_request({
                                                        type: Cocina::Models::ObjectType.collection,
                                                        label: collection_title,
                                                        version: 1,
                                                        description: {
                                                          title: CocinaDescriptionSupport.title(title: collection_title)
                                                        },
                                                        access: { view: 'world' },
                                                        administrative: { hasAdminPolicy: Settings.apo }
                                                      })

    job_id = SdrClient::RedesignedClient::CreateResource.run(accession: true, metadata: request_collection)

    job_status = SdrClient::RedesignedClient::JobStatus.new(job_id:)
    raise "Deposit failed: #{job_status.errors.join('; ')}" unless job_status.wait_until_complete

    Collection.create!(title: collection_title, druid: job_status.druid)
  end
end
