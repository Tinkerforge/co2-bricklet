Imports Tinkerforge

Module ExampleThreshold
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change to your UID

    ' Callback for co2 concentration greater than 20 ppm
    Sub ReachedCB(ByVal sender As BrickletCO2, ByVal co2Concentration As Integer)
        System.Console.WriteLine("CO2 Concentration " + (co2Concentration).ToString() + " ppm.")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim co2 As New BrickletCO2(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        co2.SetDebouncePeriod(10000)

        ' Register threshold reached callback to function ReachedCB
        AddHandler co2.CO2ConcentrationReached, AddressOf ReachedCB

        ' Configure threshold for "greater than 20 ppm"
        co2.SetCO2ConcentrationCallbackThreshold(">"C, 20, 0)

        System.Console.WriteLine("Press key to exit")
        System.Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
