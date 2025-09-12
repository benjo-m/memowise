import { StudySessionsByDay } from "@/models/user-stats";
import { Dimensions, Platform, Text, View } from "react-native";
import { BarChart } from "react-native-gifted-charts";

type Props = {
  data: StudySessionsByDay;
};

export default function SessionsByDayChart({ data }: Props) {
  const maxValue = Math.max(...Object.values(data));

  const barData = [
    { value: data.Monday, label: "M" },
    { value: data.Tuesday, label: "T" },
    { value: data.Wednesday, label: "W" },
    { value: data.Thursday, label: "T" },
    { value: data.Friday, label: "F" },
    { value: data.Saturday, label: "S" },
    { value: data.Sunday, label: "S" },
  ].map((day) => ({
    ...day,
    frontColor: day.value === maxValue ? "#177AD5" : "#76b3ecff",
  }));

  const screenWidth = Dimensions.get("window").width;
  const barWidth =
    Platform.OS == "ios" && Platform.isPad ? screenWidth * 0.025 : screenWidth * 0.065;
  const spacing = screenWidth * 0.031;

  return (
    <View
      style={{
        alignItems: "center",
        backgroundColor: "white",
        padding: 20,
        borderRadius: 20,
      }}
    >
      <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 20 }}>Sessions by day</Text>

      <Text></Text>
      <BarChart
        barWidth={barWidth}
        noOfSections={3}
        barBorderRadius={5}
        data={barData}
        yAxisThickness={0}
        xAxisThickness={0}
        maxValue={maxValue}
        disableScroll
        spacing={spacing}
        endSpacing={0}
        initialSpacing={0}
        disablePress
        minHeight={5}
      />
      <Text></Text>
    </View>
  );
}
