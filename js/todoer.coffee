# Okay, here goes

$ ->
	class Item extends Backbone.Model

		defaults: ->
			part1: 'Default Task'
			part2: 'Go do it!'
			count: 0

	class List extends Backbone.Collection
		
		model: Item

	class itemView extends Backbone.View

		tagName: 'li'
		initialize: ->
			_.bindAll @, 'render', 'unrender', 'swap', 'cross', 'remove'
			@model.bind 'change', @render
			@model.bind 'remove', @unrender

		render: ->
			$(@el).html """
			<span id="#{@model.get 'count'}">#{@model.get 'part1'} #{@model.get 'part2'}</span>
			<span class="swap button tiny secondary">done</span>
			<span class="delete button tiny alert">delete</span>
			"""

			@

		unrender: =>
			$(@el).remove()

		swap: ->
			@model.set
				part1: @model.get 'part2'
				part2: @model.get 'part1'

		cross: ->
			$(@el).css('text-decoration', 'line-through')

		remove: -> @model.destroy()

		events: 
			'click .swap' : 'cross'
			'click .delete' : 'remove'


	class toDoListView extends Backbone.View

		el: $ '#theplace'

		initialize: ->

			_.bindAll @, 'render', 'addItem', 'appendItem'

			@collection = new List
			@collection.bind 'add', @appendItem

			$('#submitter').click =>
				@theStuff = document.getElementById('taskInput').value
				$('#taskInput').val('')
				$('#mod').foundation('reveal', 'close')
				@addItem()

			@counter = 0
			@render()

		render: ->

			$(@el).append """
			<a href="#" class="button newTask" data-reveal-id="mod">New Task</a>
			<ul></ul>
				"""
		
		addItem: ->

			@counter++
			item = new Item
			item.set 
				part1: "#{@theStuff}!"
				part2: "#{item.get 'part2'} (#{@counter})"
				count: @counter
			@collection.add item

		
		appendItem: (item) ->
			item_view = new itemView model: item
			$('ul').append item_view.render().el

		#events: 'click .newTask' : 'defItem'

	Backbone.sync = (method, model, success, error) ->

		success()

	toDo_view = new toDoListView




