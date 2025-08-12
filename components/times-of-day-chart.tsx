import { Text, View } from "react-native";
import { PieChart } from "react-native-gifted-charts";

export default function TimesOfDayChart() {
  const morningColor = "#92f09dff";
  const afternoonColor = "#FFD166";
  const eveningColor = "#9B8CFF";
  const nightColor = "#5B4BFF";

  const pieData = [
    { value: 47, color: morningColor },
    { value: 40, color: afternoonColor },
    { value: 16, color: eveningColor },
    { value: 3, color: nightColor },
  ];

  const renderDot = (color: any) => {
    return (
      <View
        style={{
          height: 12,
          width: 12,
          borderRadius: 10,
          backgroundColor: color,
          marginRight: 6,
        }}
      />
    );
  };

  const renderLegendComponent = () => {
    return (
      <View style={{ width: "100%" }}>
        <View
          style={{
            flexDirection: "row",
            gap: 15,
            marginBottom: 15,
            justifyContent: "center",
          }}
        >
          <View style={{ flexDirection: "row", alignItems: "center" }}>
            {renderDot(morningColor)}
            <Text style={{}}>Morning: 47%</Text>
          </View>

          <View style={{ flexDirection: "row", alignItems: "center" }}>
            {renderDot(afternoonColor)}
            <Text style={{}}>Afternoon: 16%</Text>
          </View>
        </View>

        <View style={{ flexDirection: "row", gap: 15, justifyContent: "center" }}>
          <View style={{ flexDirection: "row", alignItems: "center" }}>
            {renderDot(eveningColor)}
            <Text style={{}}>Evening: 40%</Text>
          </View>

          <View style={{ flexDirection: "row", alignItems: "center" }}>
            {renderDot(nightColor)}
            <Text style={{}}>Night: 3%</Text>
          </View>
        </View>
      </View>
    );
  };

  return (
    <View
      style={{
        backgroundColor: "white",
        padding: 20,
        borderRadius: 20,
        alignItems: "center",
      }}
    >
      <Text style={{ fontSize: 16, fontWeight: "bold" }}>Sessions by part of day</Text>
      <View style={{ padding: 20, alignItems: "center" }}>
        <PieChart
          data={pieData}
          donut
          radius={100}
          innerRadius={60}
          centerLabelComponent={() => {
            return (
              <View style={{ justifyContent: "center", alignItems: "center" }}>
                <Text style={{ fontSize: 22, fontWeight: "bold" }}>47%</Text>
                <Text style={{ fontSize: 14 }}>Morning</Text>
              </View>
            );
          }}
        />
      </View>

      {renderLegendComponent()}
    </View>
  );
}
