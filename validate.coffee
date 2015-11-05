module.exports =
  type: 'object'
  properties:
    webwidget:
      type: 'object'
      required: ['tags','urls','transport','app']
      properties:
        tags: 
          type: 'array'
          default: ["foo","bar"]
          items: [{ "type":"string"}]
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
                css: { type: 'array', items: [{ type: 'string' }], minLength: 1 }
