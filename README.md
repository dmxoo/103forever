# 우리 반 공지

학생이 공지와 일정을 확인하고, 반장이 로그인해 내용을 관리할 수 있는 모바일 친화적 웹사이트입니다. HTML, CSS, JavaScript와 Supabase Free만 사용합니다.

## 파일 역할

- `index.html`: 최신 공지, 중요 공지, 가까운 일정이 있는 학생용 첫 화면
- `announcements.html`, `schedule.html`: 전체 공지와 일정 화면
- `login.html`, `admin.html`: 관리자 로그인과 공지·일정 관리 화면
- `css/style.css`: 모든 화면의 반응형 디자인
- `js/supabase.js`: Supabase URL 및 anon key를 넣는 유일한 설정 파일
- `js/app.js`: 반 이름, 안전한 화면 출력, 공통 도구
- `js/home.js`, `js/announcements.js`, `js/schedule.js`, `js/login.js`, `js/admin.js`: 페이지별 기능
- `supabase/schema.sql`: 테이블과 안전한 RLS 정책 생성 SQL

## 1. 필요한 계정

무료 [GitHub](https://github.com/) 계정과 [Supabase](https://supabase.com/) 계정이 필요합니다. service_role key는 절대로 웹사이트에 넣지 마세요.

## 2. Supabase 프로젝트와 데이터베이스 만들기

1. Supabase에서 **New project**를 만들고 프로젝트가 준비될 때까지 기다립니다.
2. 왼쪽 **SQL Editor** → **New query**를 열고 `supabase/schema.sql`의 전체 내용을 붙여넣어 실행합니다.
3. **Authentication → Providers → Email**에서 Email 로그인을 사용합니다. 실제 서비스라면 이메일 확인도 켜는 편이 안전합니다.
4. **Authentication → Users → Add user**에서 반장 이메일과 비밀번호로 사용자를 하나 만듭니다.
5. 방금 생성한 사용자의 UUID를 복사합니다. SQL Editor에서 아래처럼 실행해 그 계정만 관리자로 지정합니다.

```sql
insert into public.admin_profiles (id, is_admin)
values ('여기에-복사한-UUID', true)
on conflict (id) do update set is_admin = true;
```

관리자를 추가할 때도 마지막 SQL을 같은 방식으로 실행합니다. `admin_profiles`는 사용자가 직접 수정할 수 없고, RLS가 관리자 계정만 공지와 일정을 변경하도록 검사합니다.

## 3. URL과 key 설정

Supabase 프로젝트 **Project Settings → API**에서 Project URL과 `anon` 또는 `publishable` key를 복사합니다. `js/supabase.js`의 두 문자열에만 붙여넣습니다.

```js
const SUPABASE_URL = 'https://프로젝트.supabase.co';
const SUPABASE_ANON_KEY = '여기에-anon-또는-publishable-key';
```

이 key는 브라우저에 공개되어도 되는 키입니다. 권한은 `schema.sql`의 RLS가 처리합니다. `service_role` key와 비밀번호는 어떤 파일에도 넣지 마세요. `js/app.js` 첫 줄의 `CLASS_NAME`을 바꾸면 반 이름도 한 곳에서 변경됩니다.

## 4. 로컬에서 실행하기

VS Code로 이 폴더를 연 뒤 **Live Server** 확장 프로그램의 `Go Live`를 누르거나, 터미널에서 `npx serve .`를 실행합니다. 브라우저에서 표시된 주소를 엽니다. HTML 파일을 더블 클릭하는 방식보다 로컬 서버 실행을 권장합니다.

## 5. 무료 공개: GitHub Pages

1. 이 폴더를 새 GitHub 저장소에 올립니다.
2. 저장소의 **Settings → Pages**로 이동합니다.
3. Source에서 **Deploy from a branch**, Branch에서 `main`과 `/ (root)`를 선택하고 저장합니다.
4. 잠시 후 보이는 `https://사용자명.github.io/저장소명/` 주소를 친구들에게 공유합니다.

GitHub Pages에서는 `js/supabase.js`의 anon/publishable key가 공개됩니다. 이는 정상이며, RLS를 해제하거나 service_role key를 추가하면 안 됩니다.

## 확인 목록

- 학생 화면: 공지·일정을 읽을 수 있음
- 관리자 화면: 로그인 전에는 `login.html`로 이동함
- 관리자 계정: 추가·수정·삭제·중요 공지 고정이 즉시 목록에 반영됨
- 일반 로그인 계정: 로그인 후에도 관리자 화면 접근이 차단되고, RLS 때문에 데이터 변경도 거부됨
- 모바일: 가로 스크롤 없이 버튼과 입력창을 누르기 쉬움

Supabase 설정 전에는 샘플 데이터를 표시하지 않고 안내 메시지를 보여줍니다. 설정 후 Supabase Table Editor에서 공지나 일정을 한 건 추가해 실제 연결을 확인하세요.
