import { StudySessionsByDay } from "@/models/user-stats";
import { Text, View } from "react-native";
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

  return (
    <View style={{ alignItems: "center", backgroundColor: "white", padding: 20, borderRadius: 20 }}>
      <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 20 }}>Sessions by day</Text>

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
        minHeight={5}
      />
    </View>
  );
}
