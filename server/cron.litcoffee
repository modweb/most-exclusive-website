# Cron jobs

    SyncedCron.options.log = no
    SyncedCron.options.collectionTTL = 3600 #1 hour

    SyncedCron.add
      name: 'Pop and serve next ticket'
      schedule: (parser) -> parser.text 'every 1 seconds'
      job: -> QueueMethods.popAndServeNextTicket()

Start Jobs

    SyncedCron.start()
