import { Text, View } from "react-native";
import { BarChart } from "react-native-gifted-charts";

export default function SessionsByDayChart() {
  const barData = [
    { value: 10, label: "M", frontColor: "#76b3ecff" },
    { value: 12, label: "T", frontColor: "#177AD5" },
    { value: 5, label: "W", frontColor: "#76b3ecff" },
    { value: 3, label: "T", frontColor: "#76b3ecff" },
    { value: 6, label: "F", frontColor: "#76b3ecff" },
    { value: 9, label: "S", frontColor: "#76b3ecff" },
    { value: 11, label: "S", frontColor: "#76b3ecff" },
  ];

  return (
    <View style={{ alignItems: "center", backgroundColor: "white", padding: 20, borderRadius: 20 }}>
      <Text style={{ fontSize: 16, fontWeight: "bold", marginBottom: 20 }}>Sessions by day</Text>

      <BarChart
        barWidth={22}
        noOfSections={4}
        barBorderRadius={5}
        data={barData}
        yAxisThickness={0}
        xAxisThickness={0}
        hideRules
        maxValue={15}
        disableScroll
        spacing={16}
        disablePress
      />
    </View>
  );
}
