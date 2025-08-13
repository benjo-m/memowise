import { Text, View } from "react-native";
import { PieChart } from "react-native-gifted-charts";

type Props = {
  correctAnswers: number;
  incorrectAnswers: number;
};

export default function AnswerAccuracyRatioChart({ correctAnswers, incorrectAnswers }: Props) {
  const correctColor = "#92f09dff";
  const incorrectColor = "#ff9595ff";

  const noData = correctAnswers + incorrectAnswers == 0;

  const pieData = noData
    ? [{ value: 1, color: "#d0d0d0ff" }]
    : [
        { value: correctAnswers, color: correctColor },
        { value: incorrectAnswers, color: incorrectColor },
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
          <Text style={{}}>
            Correct:{" "}
            {noData ? 0 : ((correctAnswers / (correctAnswers + incorrectAnswers)) * 100).toFixed(1)}
            %
          </Text>
        </View>

        <View style={{ flexDirection: "row", alignItems: "center" }}>
          {renderDot(incorrectColor)}
          <Text style={{}}>
            Incorrect:{" "}
            {noData
              ? 0
              : ((incorrectAnswers / (correctAnswers + incorrectAnswers)) * 100).toFixed(1)}
            %
          </Text>
        </View>
      </View>
    );
  };

  return (
    <View style={{ backgroundColor: "white", padding: 20, borderRadius: 20, alignItems: "center" }}>
      <Text style={{ fontSize: 18, fontWeight: "bold" }}>Answer accuracy ratio</Text>
      <View style={{ padding: 20, alignItems: "center" }}>
        <PieChart
          data={pieData}
          donut
          radius={100}
          innerRadius={60}
          centerLabelComponent={() => {
            return (
              <View style={{ justifyContent: "center", alignItems: "center" }}>
                <Text style={{ fontSize: 22, fontWeight: "bold" }}>
                  {correctAnswers + incorrectAnswers}
                </Text>
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
