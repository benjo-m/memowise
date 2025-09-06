import { ImageFile } from "@/helpers/image-file";
import * as ImagePicker from "expo-image-picker";

export const pickImage = async (setImage: (img: ImageFile) => void) => {
  let result = await ImagePicker.launchImageLibraryAsync({
    mediaTypes: ["images"],
    allowsEditing: true,
    aspect: [4, 3],
    quality: 0.3,
  });

  if (!result.canceled) {
    const asset = result.assets[0];
    setImage({
      uri: asset.uri,
      name: asset.fileName || "image.jpg",
      type: asset.mimeType || "image/jpeg",
    });
  }
};
