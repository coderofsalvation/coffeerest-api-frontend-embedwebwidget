module.exports =
  type: 'object'
  properties:
    webwidget:
      type: 'object'
      required: ['id','urls','transport','app']
      properties:
        id: 
          type: 'string'
          default: 'foo'
        transport: 
          type: 'string'
          default: "http://"
        urls: 
          type: 'object'
          properties:
            js: { type: 'string', default: '/embed/js' }
            test: { type: 'string', default: '/embed/test' }
        app: 
          type: 'object'
          properties:
            files: 
              type: 'object'
              properties:
                js: { type: 'array', items: [{ type: 'string' }], minLength: 1 }
