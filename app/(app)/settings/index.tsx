import CustomButton from "@/components/custom-button";
import InputWrapper from "@/components/input-wrapper";
import { useSession } from "@/contexts/auth-context";
import colors from "@/styles/colors";
import { inputStyles } from "@/styles/inputs";
import Entypo from "@expo/vector-icons/Entypo";
import FontAwesome from "@expo/vector-icons/FontAwesome";
import FontAwesome5 from "@expo/vector-icons/FontAwesome5";
import MaterialCommunityIcons from "@expo/vector-icons/MaterialCommunityIcons";
import { router } from "expo-router";
import * as SecureStore from "expo-secure-store";
import { useState } from "react";
import {
  Alert,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";

export default function SettingsScreen() {
  const { session, signOut } = useSession();
  const [answerOneVisible, setAnswerOneVisible] = useState<boolean>(false);
  const [answerTwoVisible, setAnswerTwoVisible] = useState<boolean>(false);
  const [answerThreeVisible, setAnswerThreeVisible] = useState<boolean>(false);

  return (
    <ScrollView contentContainerStyle={{ flexGrow: 1 }}>
      <View style={{ flex: 1, justifyContent: "space-between", margin: 30 }}>
        <View style={{ gap: 30 }}>
          <View>
            <Text
              style={{
                fontSize: 18,
                color: "#333",
                fontWeight: 700,
                marginBottom: 15,
              }}
            >
              Account
            </Text>
            <View style={{ gap: 14 }}>
              <InputWrapper
                leadingIcon={<FontAwesome5 name="user-alt" size={16} color={colors.blue} />}
              >
                <TextInput
                  style={inputStyles.base}
                  defaultValue={SecureStore.getItem("email")!}
                  editable={false}
                ></TextInput>
              </InputWrapper>
              <CustomButton
                title={"Change email"}
                color={""}
                onPress={() => router.push("/settings/change-email")}
                icon={<MaterialCommunityIcons name="email" size={18} color="white" />}
              ></CustomButton>
              <CustomButton
                title={"Change password"}
                color={""}
                onPress={() => router.push("/settings/change-password")}
                icon={<Entypo name="dots-three-horizontal" size={18} color="white" />}
              ></CustomButton>
              <CustomButton
                title={"Delete account"}
                color={colors.red}
                onPress={() => router.push("/settings/delete-account")}
                icon={<FontAwesome name="user-times" size={18} color="white" />}
              ></CustomButton>
            </View>
          </View>
          <View>
            <Text
              style={{
                fontSize: 18,
                color: "#333",
                fontWeight: 700,
                marginBottom: 15,
              }}
            >
              About MemoWise
            </Text>
            <View style={{ gap: 10 }}>
              <TouchableOpacity
                onPress={() => setAnswerOneVisible((prev) => !prev)}
                style={styles.questionBox}
              >
                <View style={{ flexDirection: "row", justifyContent: "space-between" }}>
                  <Text style={styles.questionText}>What is MemoWise?</Text>
                  {answerOneVisible ? (
                    <FontAwesome name="chevron-up" size={14} color="#333" />
                  ) : (
                    <FontAwesome name="chevron-down" size={14} color="#333" />
                  )}
                </View>
                {answerOneVisible && (
                  <Text style={{ marginTop: 10 }}>
                    MemoWise is a learning app that utilizes learning techniques such as active
                    recall and spaced repetition to help you learn more efficiently and to retain
                    knowledge for longer.
                  </Text>
                )}
              </TouchableOpacity>

              <TouchableOpacity
                onPress={() => setAnswerTwoVisible((prev) => !prev)}
                style={styles.questionBox}
              >
                <View style={{ flexDirection: "row", justifyContent: "space-between" }}>
                  <Text style={styles.questionText}>How to use MemoWise?</Text>
                  {answerTwoVisible ? (
                    <FontAwesome name="chevron-up" size={14} color="#333" />
                  ) : (
                    <FontAwesome name="chevron-down" size={14} color="#333" />
                  )}
                </View>
                {answerTwoVisible && (
                  <Text style={{ marginTop: 10 }}>
                    To begin, first you create a deck. After creating a deck, you need to fill it
                    with flashcards. Flashcards have two sides, front and back. You write a question
                    on the front and an answer on the back side. After you add some flashcards to a
                    deck you can start studying them. When you start a study session, flashcards
                    scheduled for today will be displayed to you, one by one. After you read a
                    question on a flashcard, you answer it to yourself (you don't type it anywhere).
                    Once you've given your answer, in your head or out loud, you reveal the back of
                    the card to check if you were correct, then rate how well you remembered it.
                    Based on the rating you gave, the number of days after which the question will
                    be asked again is calculated using SM-2 algorithm. Make sure you rate your
                    answers truthfully to get the best results.
                  </Text>
                )}
              </TouchableOpacity>

              <TouchableOpacity
                onPress={() => setAnswerThreeVisible((prev) => !prev)}
                style={styles.questionBox}
              >
                <View style={{ flexDirection: "row", justifyContent: "space-between" }}>
                  <Text style={styles.questionText}>How does SM-2 algorithm work?</Text>
                  {answerThreeVisible ? (
                    <FontAwesome name="chevron-up" size={14} color="#333" />
                  ) : (
                    <FontAwesome name="chevron-down" size={14} color="#333" />
                  )}
                </View>
                {answerThreeVisible && (
                  <Text style={{ marginTop: 10 }}>
                    The SM-2 algorithm determines the optimal time to review a flashcard based on
                    how well you remembered it during previous reviews. Each time you rate your
                    answer, the algorithm adjusts the interval before the flashcard reappears again,
                    making easy material appear less often and difficult material more frequently.
                    Over time, this process strengthens long-term retention while minimizing
                    unnecessary repetition. Flashcards rated 3 and below will be asked again, in the
                    same session, until they are rated 4 or 5.
                  </Text>
                )}
              </TouchableOpacity>
            </View>
          </View>
        </View>

        <View style={{ marginTop: 30 }}>
          <CustomButton
            title={"Sign out"}
            color={colors.gray}
            onPress={() => {
              Alert.alert(
                "Sign out",
                "Are you sure you want to sign out?",
                [
                  { text: "No", style: "cancel" },
                  { text: "Yes", onPress: () => signOut() },
                ],
                { cancelable: true }
              );
            }}
            icon={<MaterialCommunityIcons name="logout" size={18} color="white" />}
          ></CustomButton>
          <CustomButton
            title={"Get token"}
            color={""}
            onPress={() => console.log(session)}
            icon={undefined}
          ></CustomButton>
        </View>
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  questionBox: {
    backgroundColor: "white",
    paddingVertical: 16,
    paddingHorizontal: 10,
    borderRadius: 10,
  },
  questionText: {
    fontWeight: 500,
  },
});
