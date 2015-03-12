# Cron jobs

    SyncedCron.options.log = no

    SyncedCron.add
      name: 'Pop and serve next ticket'
      schedule: (parser) -> parser.text 'every 1 seconds'
      job: -> QueueMethods.popAndServeNextTicket()

Start Jobs

    SyncedCron.start()
