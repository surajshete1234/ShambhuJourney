# Add real media here

Drop real photos/videos in this folder using these exact file names (matching
`Sources/SampleData/SampleJourneyData.swift`) and they'll automatically replace the
placeholders throughout the app:

| File name              | Type  | Used for                     |
|-------------------------|-------|-------------------------------|
| month1_test.jpg         | photo | Month 1 · The Beginning       |
| month2_scan.jpg          | photo | Month 2 · First Heartbeat     |
| month3_bump.jpg          | photo | Month 3 · Our Secret          |
| month4_announcement.jpg  | photo | Month 4 · Telling the World   |
| month5_kicks.mov         | video | Month 5 · First Kicks         |
| month6_bump.jpg          | photo | Month 6 · Growing Strong      |
| month7_nursery.jpg       | photo | Month 7 · Nursery Dreams      |
| month8_bump.jpg          | photo | Month 8 · Almost There        |
| month9_bump.jpg          | photo | Month 9 · The Final Wait      |
| shambhu_arrival.jpg      | photo | Shambhu's Arrival             |

Supported extensions: jpg, jpeg, png, heic (photos) and mov, mp4 (videos).

After adding files here, re-run `xcodegen generate` (or, if you added this project
folder as a "folder reference" / synced group in Xcode, the files appear automatically
the next time you build).

You are not limited to these ten — add as many milestones and media items as you like by
editing `SampleJourneyData.swift`, or use the in-app "+" button on any timeline card to
import photos/videos straight from your Photos library (no rebuild needed).
