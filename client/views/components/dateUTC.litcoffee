    Template.dateUTC.helpers
      dateUTCPretty: ->
        (moment this.value).format 'h:mm:ss A'
