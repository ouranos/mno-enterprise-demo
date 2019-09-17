angular.module 'mnoEnterpriseAngular'

#======================================================================================
# IMPAC-ROUTES: Configuring routes
#======================================================================================
.config((ImpacRoutesProvider, IMPAC_CONFIG) ->
  mnoHub = IMPAC_CONFIG.paths.mnohub_api

  data =
    mnoHub: mnoHub
    impacApi: "#{IMPAC_CONFIG.protocol}://#{IMPAC_CONFIG.host}/api"
    kpis:
      index: "#{mnoHub}/impac/kpis"

  bolts = [{ provider: 'maestrano', name: 'finance', category: 'accounts' }]

  ImpacRoutesProvider.configureRoutes(data)
  ImpacRoutesProvider.configureBolts('v2', bolts)
)

#======================================================================================
# IMPAC-THEMING: Configuring colour theme, layout, labels, descriptions, and features
#======================================================================================
.config((ImpacThemingProvider) ->
  options =
    # link to the marketplace
    dataNotFoundConfig:
      linkUrl: 'marketplace'
    # remove useless messages
    dhbErrorsConfig:
      firstTimeCreated:
        note: ''
    dhbConfig:
      multiCompany: true
    # configurations for the dashboard selector feature.
    dhbSelectorConfig:
      pdfModeEnabled: true
    # kpis options
    dhbKpisConfig:
      enableKpis: true
    # alert notifications options
    alertsConfig:
      enableAlerts: true
    widgetSettings:
      tagging:
        enabled: true
    widgetSelectorConfig:
      blacklist: [
        'maestrano/finance/account_balance'
        'maestrano/finance/assets_summary'
        'maestrano/finance/balance_sheet'
        'maestrano/finance/classifications_summary'
        'maestrano/finance/current_ratio'
        'maestrano/finance/debt_service_ratio'
        'maestrano/finance/detailed_classifications'
        'maestrano/finance/ebitda'
        'maestrano/finance/expense_weight'
        'maestrano/finance/expenses_revenue'
        'maestrano/finance/overall_turnover'
        'maestrano/finance/profit_and_loss'
        'maestrano/finance/accounts_comparison'
        'maestrano/finance/payable_receivable'
        'maestrano/finance/aged_payables_receivables'
        'maestrano/finance/average_profit'
      ]

  ImpacThemingProvider.configure(options)
)

#======================================================================================
# IMPAC-ASSETS: Configuring assets
#======================================================================================
.config((ImpacAssetsProvider) ->
  options =
    defaultImagesPath: '/dashboard/images'

  ImpacAssetsProvider.configure(options)
)

#======================================================================================
# IMPAC-LINKING: Configuring linking
#======================================================================================
.run((ImpacLinking, ImpacConfigSvc, IMPAC_CONFIG) ->
  data =
    user: ImpacConfigSvc.getUserData
    organizations: ImpacConfigSvc.getOrganizations

  data.pusher_key = IMPAC_CONFIG.pusher.key if IMPAC_CONFIG.pusher? && IMPAC_CONFIG.pusher.key?

  ImpacLinking.linkData(data)
)
