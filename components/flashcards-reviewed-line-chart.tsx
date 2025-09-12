import { FlashcardsReviewedByDayEntry } from "@/models/user-stats";
import { Dimensions, Platform, Text, View } from "react-native";
import { LineChart } from "react-native-gifted-charts";
type Props = {
  dataArr: FlashcardsReviewedByDayEntry[];
};
export default function FlashcardsReviewedLineChart({ dataArr }: Props) {
  const customLabel = (val: any) => {
    return (
      <View style={{ width: 100, marginLeft: 4 }}>
        <Text style={{ fontWeight: "500", fontSize: 12 }}>{val}</Text>
      </View>
    );
  };

  const max = Math.max(...dataArr.map((entry) => entry.count)) * 1.1;

  const data = dataArr.map((entry, index) => {
    const showLabel = index === 0 || index === dataArr.length - 1 || index === 3;
    return {
      value: entry.count,
      labelComponent: showLabel
        ? () =>
            customLabel(
              new Date(entry.date).toLocaleDateString("en-GB", { day: "2-digit", month: "2-digit" })
            )
        : undefined,
    };
  });

  const screenWidth = Dimensions.get("screen").width;
  // const spacing = screenWidth * 0.1
  const spacing = Platform.OS == "ios" && Platform.isPad ? screenWidth * 0.055 : screenWidth * 0.1;

  const initalSpacing =
    Platform.OS == "ios" && Platform.isPad ? screenWidth * 0.025 : screenWidth * 0.02;
  const endSpacing = screenWidth * 0.01;

  return (
    <View
      style={{
        backgroundColor: "white",
        padding: 20,
        borderRadius: 20,
        alignItems: "center",
      }}
    >
      <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 20 }}>
        Flashcards reviewed (last 7d)
      </Text>
      <LineChart
        thickness={6}
        color="#07BAD1"
        maxValue={max}
        mostNegativeValue={1}
        noOfSections={3}
        areaChart
        yAxisTextStyle={{ color: "gray" }}
        xAxisThickness={0}
        data={data}
        startFillColor="rgb(84,219,234)"
        endFillColor="rgb(84,219,234)"
        startOpacity={0.4}
        endOpacity={0.4}
        spacing={spacing}
        endSpacing={endSpacing}
        initialSpacing={initalSpacing}
        yAxisColor="white"
        xAxisColor="lightgray"
        dataPointsHeight={20}
        dataPointsWidth={20}
      />
      <Text></Text>
    </View>
  );
}
