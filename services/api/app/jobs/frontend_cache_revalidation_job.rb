class FrontendCacheRevalidationJob < ApplicationJob
  queue_as :default

  FRONTEND_URL = ENV.fetch('FRONTEND_URL', 'http://web:3000')

  def perform(tags: nil, path: nil)
    raise ArgumentError, 'Provide either tags or path' if tags.nil? && path.nil?

    body = if tags
      { tags: tags }
    else
      { path: path }
    end

    response = HTTParty.post(
      "#{FRONTEND_URL}/api/revalidate",
      headers: { 'Content-Type' => 'application/json' },
      body: body.to_json
    )

    log_response(response, tags:, path:)
  rescue => e
    Rails.logger.error("Cache revalidation failed: #{e.message}")
    false
  end

  private

  def log_response(response, tags:, path:)
    target = tags ? "tags: #{tags.join(', ')}" : "path: #{path}"

    if response.success?
      Rails.logger.info("Revalidation triggered for #{target}")
    else
      Rails.logger.error("Revalidation failed for #{target}: #{response.code} #{response.body}")
    end
  end
end
