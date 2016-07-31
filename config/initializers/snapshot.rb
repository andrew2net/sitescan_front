require 'snapshot/renderer'
Rails.application.config.middleware.use(Snapshot::Renderer)
