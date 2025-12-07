# Statistics Component - Showcasing data visualization
# Demonstrates: Computed properties, template literals, dynamic rendering

export default class StatsComponent
  constructor: (@container, @store) ->

  render: ->
    stats = @store.getStats()

    categoryBadges = Object.entries(stats.byCategory)
      .map(([category, count]) -> "<span class=\"stat-badge\">#{category}: <strong>#{count}</strong></span>")
      .join('')

    priorityBadges = Object.entries(stats.byPriority)
      .map(([priority, count]) -> "<span class=\"stat-badge priority-#{priority}\">#{priority}: <strong>#{count}</strong></span>")
      .join('')

    progressBarWidth = stats.completionPercentage
    progressBarColor = switch
      when stats.completionPercentage is 100 then '#10b981'
      when stats.completionPercentage >= 75 then '#06b6d4'
      when stats.completionPercentage >= 50 then '#3b82f6'
      when stats.completionPercentage >= 25 then '#f59e0b'
      else '#ef4444'

    @container.innerHTML = '''
      <div class="stats-panel">
        <div class="stats-header">
          <h3>📊 Progress</h3>
          <div class="stat-summary">
            <span class="stat-item">
              <span class="stat-label">Total:</span>
              <span class="stat-value">#{stats.total}</span>
            </span>
            <span class="stat-item">
              <span class="stat-label">Done:</span>
              <span class="stat-value">#{stats.completed}</span>
            </span>
            <span class="stat-item">
              <span class="stat-label">Active:</span>
              <span class="stat-value">#{stats.active}</span>
            </span>
            #{if stats.overdue > 0 then "<span class=\"stat-item overdue\"><span class=\"stat-label\">Overdue:</span><span class=\"stat-value\">#{stats.overdue}</span></span>" else ''}
          </div>
        </div>

        <div class="progress-section">
          <div class="progress-header">
            <span class="progress-label">Completion</span>
            <span class="progress-percentage">#{stats.completionPercentage}%</span>
          </div>
          <div class="progress-bar">
            <div class="progress-fill" style="width: #{progressBarWidth}%; background-color: #{progressBarColor};"></div>
          </div>
        </div>

        <div class="stats-section">
          <h4>By Category</h4>
          <div class="stat-badges">#{categoryBadges}</div>
        </div>

        <div class="stats-section">
          <h4>By Priority</h4>
          <div class="stat-badges">#{priorityBadges}</div>
        </div>
      </div>
    '''

  update: ->
    @render()
