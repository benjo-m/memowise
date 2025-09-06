import { getUserStats } from "@/api/users";
import AnswerAccuracyRatioChart from "@/components/answer-accuracy-ratio-chart";
import FlashcardsReviewedLineChart from "@/components/flashcards-reviewed-line-chart";
import SessionsByDayChart from "@/components/sessions-by-day-chart";
import TimesOfDayChart from "@/components/times-of-day-chart";
import { useUserStats } from "@/contexts/user-stats-context";
import Ionicons from "@expo/vector-icons/Ionicons";
import React, { useEffect, useState } from "react";
import { ActivityIndicator, ScrollView, Text, View } from "react-native";

export default function StatsScreen() {
  const { userStats, setUserStats } = useUserStats();
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const loadUserStats = async () => {
    const data = await getUserStats();
    setUserStats(data);
    setLoading(false);
  };

  useEffect(() => {
    loadUserStats();
  }, []);

  if (loading) {
    return (
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
        <ActivityIndicator />
      </View>
    );
  }

  if (error) {
    return (
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
        <Text style={{ color: "red" }}>{error}</Text>
      </View>
    );
  }

  if (!userStats) return null;

  function formatTime(seconds: number) {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    return `${hours}h ${minutes}m`;
  }

  return (
    <ScrollView contentContainerStyle={{ margin: 30 }}>
      <View
        style={{ flexDirection: "row", justifyContent: "space-between", marginBottom: 10, gap: 10 }}
      >
        <View
          style={{
            backgroundColor: "#ffffff",
            borderRadius: 15,
            paddingVertical: 16,
            alignItems: "center",
            flex: 1,
          }}
        >
          <Ionicons name="flame" size={28} color="#F97316" style={{ marginBottom: 5 }} />
          <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 5 }}>
            {userStats.current_study_streak}d
          </Text>
          <Text style={{ fontSize: 12, color: "#555" }}>Current</Text>
          <Text style={{ fontSize: 12, color: "#555" }}>study streak</Text>
        </View>

        <View
          style={{
            backgroundColor: "#ffffff",
            borderRadius: 15,
            paddingVertical: 16,
            alignItems: "center",
            flex: 1,
          }}
        >
          <Ionicons name="trophy" size={28} color="#EAB308" style={{ marginBottom: 5 }} />
          <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 5 }}>
            {userStats.longest_study_streak}d
          </Text>
          <Text style={{ fontSize: 12, color: "#555" }}>Longest</Text>
          <Text style={{ fontSize: 12, color: "#555" }}>study streak</Text>
        </View>

        <View
          style={{
            backgroundColor: "#ffffff",
            borderRadius: 15,
            paddingVertical: 16,
            alignItems: "center",
            flex: 1,
          }}
        >
          <Ionicons name="time" size={28} color="#2563EB" style={{ marginBottom: 5 }} />
          <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 5 }}>
            {formatTime(userStats.total_time_spent_studying)}
          </Text>
          <Text style={{ fontSize: 12, color: "#555" }}>Total</Text>
          <Text style={{ fontSize: 12, color: "#555" }}>time studied</Text>
        </View>
      </View>

      <View
        style={{
          backgroundColor: "#ffffff",
          padding: 15,
          borderRadius: 15,
          marginVertical: 10,
        }}
      >
        <Text style={{ fontSize: 18, fontWeight: "bold", marginBottom: 5 }}>Summary</Text>
        <Text style={{ fontSize: 14, color: "#374151", fontWeight: "500" }}>
          You’ve studied{" "}
          <Text style={{ fontWeight: "bold" }}>{userStats.total_study_sessions}</Text> times,
          spending a total of{" "}
          <Text style={{ fontWeight: "bold" }}>
            {formatTime(userStats.total_time_spent_studying)}
          </Text>{" "}
          learning.{"\n"}
          Your average study session lasts{" "}
          <Text style={{ fontWeight: "bold" }}>
            {Math.round(userStats.average_session_duration / 60)}
          </Text>{" "}
          minutes, and you review about{" "}
          <Text style={{ fontWeight: "bold" }}>
            {userStats.average_flashcards_reviewed_per_session.toFixed(1)}
          </Text>{" "}
          flashcards per session.{"\n"}
          {userStats.favorite_deck ? (
            <>
              Your favorite deck is{" "}
              <Text style={{ fontWeight: "bold" }}>{userStats.favorite_deck.deck}</Text>, which
              you’ve studied{" "}
              <Text style={{ fontWeight: "bold" }}>{userStats.favorite_deck.count}</Text> times.
            </>
          ) : (
            <>You don’t have a favorite deck yet — time to start one!</>
          )}
        </Text>
      </View>

      <View style={{ marginVertical: 10 }}>
        <SessionsByDayChart data={userStats.study_sessions_by_day} />
      </View>

      <View style={{ marginVertical: 10 }}>
        <TimesOfDayChart data={userStats.study_sessions_by_part_of_day} />
      </View>

      <View style={{ marginVertical: 10 }}>
        <FlashcardsReviewedLineChart
          dataArr={userStats.flashcards_reviewed_by_day}
        ></FlashcardsReviewedLineChart>
      </View>

      <View style={{ marginVertical: 10, marginBottom: 30 }}>
        <AnswerAccuracyRatioChart
          correctAnswers={userStats.total_correct_answers}
          incorrectAnswers={userStats.total_incorrect_answers}
        />
      </View>
    </ScrollView>
  );
}
