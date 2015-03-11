# Cron jobs

    SyncedCron.add
      name: 'Pop and serve next ticket'
      schedule: (parser) -> parser.text 'every 5 seconds'
      job: -> QueueMethods.popAndServeNextTicket()

Start Jobs

    SyncedCron.start()
