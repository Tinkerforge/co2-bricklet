Imports System
Imports Tinkerforge

Module ExampleThreshold
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change to your UID

    ' Callback subroutine for CO2 concentration reached callback (parameter has unit ppm)
    Sub CO2ConcentrationReachedCB(ByVal sender As BrickletCO2, ByVal co2Concentration As Integer)
        Console.WriteLine("CO2 Concentration: " + co2Concentration.ToString() + " ppm")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim co2 As New BrickletCO2(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        co2.SetDebouncePeriod(10000)

        ' Register CO2 concentration reached callback to subroutine CO2ConcentrationReachedCB
        AddHandler co2.CO2ConcentrationReached, AddressOf CO2ConcentrationReachedCB

        ' Configure threshold for co2_concentration "greater than 750 ppm" (unit is ppm)
        co2.SetCO2ConcentrationCallbackThreshold(">"C, 750, 0)

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
