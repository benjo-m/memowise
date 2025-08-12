import { Text, View } from "react-native";
import { PieChart } from "react-native-gifted-charts";

export default function AnswerAccuracyRatioChart() {
  const correctColor = "#92f09dff";
  const incorrectColor = "#ff7a7aff";

  const pieData = [
    { value: 7, color: correctColor },
    { value: 2, color: incorrectColor },
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
      <View
        style={{
          flexDirection: "row",
          gap: 15,
          marginBottom: 15,
          justifyContent: "center",
        }}
      >
        <View style={{ flexDirection: "row", alignItems: "center" }}>
          {renderDot(correctColor)}
          <Text style={{}}>Correct: 91%</Text>
        </View>

        <View style={{ flexDirection: "row", alignItems: "center" }}>
          {renderDot(incorrectColor)}
          <Text style={{}}>Incorrect: 9%</Text>
        </View>
      </View>
    );
  };

  return (
    <View style={{ backgroundColor: "white", padding: 20, borderRadius: 20, alignItems: "center" }}>
      <Text style={{ fontSize: 16, fontWeight: "bold" }}>Answer accuracy ratio</Text>
      <View style={{ padding: 20, alignItems: "center" }}>
        <PieChart
          data={pieData}
          donut
          radius={100}
          innerRadius={60}
          centerLabelComponent={() => {
            return (
              <View style={{ justifyContent: "center", alignItems: "center" }}>
                <Text style={{ fontSize: 22, fontWeight: "bold" }}>129</Text>
                <Text style={{ fontSize: 14 }}>Answers</Text>
              </View>
            );
          }}
        />
      </View>

      {renderLegendComponent()}
    </View>
  );
}
