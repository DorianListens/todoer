# Okay, here goes

$ ->
	class Item extends Backbone.Model

		defaults: ->
			task: 'Default Task.'
			part2: 'Go do it!'
			done: false
			order: toDoListView.nextOrder
			count: 0

		toggle: ->
			@save done: !@get('done')

	class List extends Backbone.Collection
		
		model: Item

		done: ->
			@where {done: true}

		remaining: ->
			@where {done: false}

		nextOrder: ->
			if !@length
				1
				@last().get 'order' + 1

		comparator: 'order'

	class itemView extends Backbone.View

		tagName: 'div'
		className: 'row itemView'
		initialize: ->
			_.bindAll @, 'render', 'unrender', 'cross', 'remove', 'edit', 'updateOnEnter', 'close'
			@model.bind 'change', @render
			@model.bind 'remove', @unrender

		render: ->

			$(@el).html """
			<div class="small-6 columns"><input class="edit" type="text" value = "#{@model.get 'task'}"/></div>
			<div id="info" class="small-6 columns">#{@model.get 'task'} #{@model.get 'part2'}</div>
			<div class="small-4 columns small-offset-2">
				<span class="cross button tiny secondary">done</span>
				<span class="delete button tiny alert">delete</span>
			</div>	
			"""

			@.$('#info').toggleClass 'done', @model.get 'done'
			@input = @.$.edit

			@

		unrender: =>
			$(@el).remove()

		edit: =>
			@.$el.toggleClass 'editing'
			@.$('input').focus()

		close: =>
			value = @input.val()
			if !value
				@remove
			else
				@model.save task: value
				@.$el.toggleClass 'editing'

		
		updateOnEnter: (e) => 
			@close if e.keyCode is 13
				
		cross: ->
			#@.$('#info').css('text-decoration', 'line-through').css('color', 'red')
			@model.toggle()


		remove: -> @model.destroy()

		events: 
			'click .cross' : 'cross'
			'click .delete' : 'remove'
			'dblclick #info' : 'edit'
			'keypress .edit' : 'updateOnEnter'
			'blur .edit' : 'updateOnEnter'


	class toDoListView extends Backbone.View

		el: $ '#theplace'

		initialize: ->

			_.bindAll @, 'render', 'addItem', 'appendItem'

			@collection = new List
			@collection.bind 'add', @appendItem

			$('#submitter').click =>
				@theTask = document.getElementById('taskInput').value
				$('#taskInput').val('')
				$('#mod').foundation('reveal', 'close')
				@addItem()

			#$('#mod').data('reveal-init', options)
       					 
			@counter = 0
			@render()

		render: ->

			$(@el).append """
			<a href="#" class="button newTask" data-reveal-id="mod">New Task</a>
				<div class="row">
					<div class="small-6 columns"><h2>Task Name</h2></div>
					<div class="small-4 small-offset-2 columns"><h2>Task Actions</h2></div>
					<hr /></div>

			<ul></ul>
				"""
		
		addItem: ->

			@counter++
			item = new Item
			if @theTask
				item.set task: "#{@theTask}!" 
			item.set 
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

