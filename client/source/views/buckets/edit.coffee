_ = require 'underscore'

PageView = require 'views/base/page'
BucketFieldsView = require 'views/buckets/fields'
MembersList = require 'views/members/list'
FormMixin = require 'views/base/mixins/form'
tpl = require 'templates/buckets/edit'

module.exports = class BucketEditView extends PageView

  template: tpl

  optionNames: PageView::optionNames.concat ['fields', 'members', 'users']

  regions:
    'fields': '#fields'
    'members': '#members'

  events:
    'submit form': 'submitForm'
    'click .swatches div': 'selectSwatch'
    'click [href="#delete"]': 'clickDelete'

  render: ->
    super
    @subview 'bucketFields', new BucketFieldsView
      collection: @fields
      region: 'fields'

    if @members and @users
      @subview 'bucketMembers', new MembersList
        collection: @members
        bucket: @model
        users: @users
        region: 'members'

  submitForm: (e) ->
    e.preventDefault()
    data = @formParams()

    data.color = @$('.colors div.selected').data('value')
    data.icon = @$('.icons div.selected').data('value')
    data.fields = @fields.toJSON()

    @submit @model.save(data, wait: yes)

  selectSwatch: (e) ->
    e.preventDefault()
    $el = @$(e.currentTarget)
    $el.addClass('selected').siblings().removeClass 'selected'

  clickDelete: (e) ->
    e.preventDefault()
    if confirm 'Are you sure?'
      @model.destroy wait: yes

  setActiveTab: (idx) ->
    @$('.nav-tabs li').eq(idx-1).find('a').click()

  @mixin FormMixin
