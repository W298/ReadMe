# Read Me
## 서버 설정
|| /Base64Image| /GetChar|
| ------ | ------ | ------ |
| REQUEST| JSON| Binary File|
| RETURN| JSON|  JSON|
### 1. /Base64Image
 - Request : JSON (Image)
```json
{'image' : image_base64, 'date' : current_date, 'gender' : gender_voice}
```
- `image_base64` : 이미지를 Base64로 인코딩한 String
- `current_date` : 이미지를 보낸 시각 (파일 이름)
- `gender` : 음성의 성별 (`"M"` : Man, `"W"` : Woman, `"N"` : Neutral)
---
- Return : JSON (Audio)
```json
{'audio' : audio_base64}
```
- `audio_base64` : Base64로 인코딩된 오디오

### 2. /GetChar
 - Request : Binary File (Image)
---
- Return : JSON (Audio)
```json
{'audio' : audio_base64}
```
- `audio_base64` : Base64로 인코딩된 오디오
