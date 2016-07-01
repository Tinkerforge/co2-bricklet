Imports System
Imports Tinkerforge

Module ExampleCallback
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change XYZ to the UID of your CO2 Bricklet

    ' Callback subroutine for CO2 concentration callback (parameter has unit ppm)
    Sub CO2ConcentrationCB(ByVal sender As BrickletCO2, _
                           ByVal co2Concentration As Integer)
        Console.WriteLine("CO2 Concentration: " + co2Concentration.ToString() + " ppm")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim co2 As New BrickletCO2(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Register CO2 concentration callback to subroutine CO2ConcentrationCB
        AddHandler co2.CO2Concentration, AddressOf CO2ConcentrationCB

        ' Set period for CO2 concentration callback to 1s (1000ms)
        ' Note: The CO2 concentration callback is only called every second
        '       if the CO2 concentration has changed since the last call!
        co2.SetCO2ConcentrationCallbackPeriod(1000)

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
