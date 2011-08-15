namespace :sources do
  # How old should a source be before it needs to be refreshed?
  SOURCE_STALE = Time.now - 1.hour

  # How old should an update be before it needs to be deleted?
  UPDATE_STALE = Time.now - 2.weeks

  desc 'Get updates from our sources'
  task :update => :environment do
    sources = Source.find(:all, :order => "imported_at",
      :conditions => ['reimport = ? and imported_at < ?', true, SOURCE_STALE])
    puts "Nothing to do" unless sources.size > 0

    sources.each do |source|
      print "Polling #{source.name}: "
      begin
        events = source.create_events!
        msg = "created #{events.size} events"
      rescue Exception => e
        msg = e.to_s
      end
      puts msg
      source.updates.create(:status => msg)
      source.imported_at = Time.now
      source.save!
    end

    # get rid of log entries older than two weeks
    Update.find(:all, :conditions => ['created_at < ?', UPDATE_STALE]).each do |u|
      u.destroy
    end
  end

  desc 'Show update status for each source'
  task :status => :environment do
    sources = Source.find(:all, :conditions => {:reimport => true})
    sources.each do |source|
      puts "#{source.name}"
      last_poll = Update.find_by_source_id(source.id, :order => 'imported_at desc')
      if last_poll
        puts "  #{last_poll.created_at}: #{last_poll.status}"
      else
        puts "  no updates"
      end
    end
  end

  desc "Reset source import_at dates to force full reimport"
  task :reset => :environment do
    puts "Resetting source imported_at dates:"
    Source.find(:all, :conditions => {:reimport => true}).each do |source|
      puts "- #{source.name}"
      source.update_attribute(:imported_at, Time.at(0))
    end
  end
end

