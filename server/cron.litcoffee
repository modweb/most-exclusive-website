# Cron jobs

    SyncedCron.options.log = no
    SyncedCron.options.collectionTTL = 3600 #1 hour

    SyncedCron.add
      name: 'Pop and serve next ticket'
      schedule: (parser) -> parser.text 'every 2 seconds'
      job: -> QueueMethods.popAndServeNextTicket()

    SyncedCron.add
      name: 'Clean up dead connections'
      schedule: (parser) -> parser.text 'every 1 minutes'
      job: -> QueueMethods.cleanUpDeadConnections()

Start Jobs

    SyncedCron.start()
