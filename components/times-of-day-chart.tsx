import { StudySessionsByPartOfDay } from "@/models/user-stats";
import { Text, View } from "react-native";
import { PieChart } from "react-native-gifted-charts";

type Props = {
  data: StudySessionsByPartOfDay;
};

export default function TimesOfDayChart({ data }: Props) {
  const morningColor = "#92f09dff";
  const afternoonColor = "#FFD166";
  const eveningColor = "#9B8CFF";
  const nightColor = "#5B4BFF";

  const timesOfDay = [
    { label: "Morning", value: data.morning },
    { label: "Afternoon", value: data.afternoon },
    { label: "Evening", value: data.evening },
    { label: "Night", value: data.night },
  ];

  const total = timesOfDay.reduce((sum, t) => sum + t.value, 0);

  const maxEntry = timesOfDay.reduce(
    (prev, curr) => (curr.value > prev.value ? curr : prev),
    timesOfDay[0]
  );

  const maxPercentage = total > 0 ? ((maxEntry.value / total) * 100).toFixed(0) : "0";

  const getPercentage = (value: number) => (total > 0 ? ((value / total) * 100).toFixed(0) : 0);

  const noData = data.morning == 0 && data.afternoon == 0 && data.evening == 0 && data.night == 0;

  const pieData = noData
    ? [{ value: 1, color: "#d0d0d0ff" }]
    : [
        { value: data.morning, color: morningColor },
        { value: data.afternoon, color: afternoonColor },
        { value: data.evening, color: eveningColor },
        { value: data.night, color: nightColor },
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
            <Text style={{}}>Morning: {getPercentage(data.morning)}%</Text>
          </View>

          <View style={{ flexDirection: "row", alignItems: "center" }}>
            {renderDot(afternoonColor)}
            <Text style={{}}>Afternoon: {getPercentage(data.afternoon)}%</Text>
          </View>
        </View>

        <View style={{ flexDirection: "row", gap: 15, justifyContent: "center" }}>
          <View style={{ flexDirection: "row", alignItems: "center" }}>
            {renderDot(eveningColor)}
            <Text style={{}}>Evening: {getPercentage(data.evening)}%</Text>
          </View>

          <View style={{ flexDirection: "row", alignItems: "center" }}>
            {renderDot(nightColor)}
            <Text style={{}}>Night: {getPercentage(data.night)}%</Text>
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
      <Text style={{ fontSize: 18, fontWeight: "bold" }}>Sessions by part of day</Text>
      <View style={{ padding: 20, alignItems: "center" }}>
        <PieChart
          data={pieData}
          donut
          radius={100}
          innerRadius={60}
          centerLabelComponent={() => {
            return (
              <View style={{ justifyContent: "center", alignItems: "center" }}>
                <Text style={{ fontSize: 22, fontWeight: "bold" }}>{maxPercentage}%</Text>
                <Text style={{ fontSize: 14 }}>{noData ? "No data" : maxEntry.label}</Text>
              </View>
            );
          }}
        />
      </View>

      {renderLegendComponent()}
    </View>
  );
}
