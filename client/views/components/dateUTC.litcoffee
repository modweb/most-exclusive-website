    Template.dateUTC.helpers
      dateUTCPretty: ->
        (moment this.value).format this.format
