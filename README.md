# Sample-WebAPI-WinForms-Pascal

This sample application uses Pascal with .NET 4.0 (Oxygene for .NET) to authenticate with the TradeStation API via an OAuth 2 Authorization Code Grant Type. The user will be directed to TradeStation's login page to capture credentials. After a successful login, an auth code is returned and is then exchanged for an access token which will be used for subsequent WebAPI calls.
The application allows you to get historical data and draw it in a chart with zoom support. It also helps you predict when a stock value is going to occur.

## Configuration
Modify the following fields in the app.config with your appropriate values:

	<applicationSettings>
		<SampleWebAPIWinFormsPascal.Properties.Settings>
			<setting name="APIKey" serializeAs="String">
				<value>your key goes here</value>
			</setting>
			<setting name="APISecret" serializeAs="String">
				<value>your secret goes here</value>
				</setting>
			<setting name="RedirectURI" serializeAs="String">
				<value>your redirect URI goes here</value> // Example: http://www.tradestation.com
			</setting>
			<setting name="Environment" serializeAs="String">
				<value>Can be "SIM" or "LIVE"</value>
			</setting>
			<setting name="Interval" serializeAs="String">
				<value>5</value> // This means data will be retrieved every 5 minutes
			</setting>
		</SampleWebAPIWinFormsPascal.Properties.Settings>
	</applicationSettings>

## Build Instructions
* Download and Extract the zip or clone this repo
* Open Visual Studio, make sure you have installed Oxygene
* Build and Run

## Troubleshooting
If there are any problems, open an [issue](https://github.com/tradestation/Sample-WebAPI-WinForms-Pascal/issues) and we'll take a look! You can also give us feedback by e-mailing webapi@tradestation.com.
