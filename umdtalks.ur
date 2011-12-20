table lists : {
	Id : int,
	Title : string,
	Details : string,
	Image_id : int,
	Created_at : time,
	Updated_at : time
}
	(*Kind : string,*)
	(*Details_filter : string,*)
	(*Ex_directory : bool,*)
	PRIMARY KEY Id

sequence listSeq

table lists_lists : {
	Parent_id : int,
	Child_id : int
}

table talks : {
	Id : int,
	Title : string,
	Abstract : string,
	Start_time : time,
	End_time : time,
	Speaker_name : string,
	Venue : string,
	Created_at : time,
	Updated_at : time,
	Image_id : int
}
	(*Speaker_id : int,
	Series_id : int,
	Venue_id : int,*)
	(*Special_message : string,
	Abstract_filtered : string,*)
	(*Organiser_id : int,*)
	PRIMARY KEY Id

sequence talkSeq

table lists_talks : {
	Parent_id : int,
	Talk_id : int
}

table users : {
	Id : int,
	Email : string,
	Alias : string,
	Password : string,
	Affiliation : string,
	(*Administrator : int,*)
	Last_login : time,
	Image_id : int,
	Created_at : time,
	Updated_at : time,
	Session_crumb: string
}
	PRIMARY KEY Id

sequence userSeq

table list_owners : {
	Owner_id : int,
	List_id : int
}

table talk_owners : {
	Owner_id : int,
	Talk_id : int
}

(* Organizations?? or just organizers. *)

style wrapper
style header
style content
style footer
style right
style left
style login
style box
style details
style title
style hdiv
style abstract
style button

datatype inputError =
	| INone
	| IError of string (* cross with the row (prev values)?? *)

cookie userSession : {Username : string, Session_crumb : string}

(*type user = int * string*)

(* Gets the logged in user. *)
fun getUser () =
	cook <- getCookie userSession;
	( case cook of
		| None => return None
		| Some c =>
			(* get userid, call getUserWithId? *)
			user <- oneOrNoRows1 (SELECT users.Id, users.Email, users.Alias, users.Affiliation, users.Last_login, users.Created_at, users.Updated_at FROM users WHERE users.Email = {[c.Username]} AND users.Session_crumb = {[c.Session_crumb]});
			( case user of
				| None =>
					return None
				| Some u =>
					return (Some u)
			)
	)

(* Gets the user record with the given id. *)
fun getUserWithId id =
	user <- oneOrNoRows1 (SELECT users.Id, users.Email, users.Alias, users.Affiliation, users.Last_login, users.Created_at, users.Updated_at FROM users WHERE users.Id = {[id]});
	( case user of
		| None => return None
		| Some u =>
			return (Some u)
	)


fun unimplemented () = return <xml>
	<body>
		Unimplemented
	</body>
</xml>

fun search r = return <xml>
	<body>
		Unimplemented
	</body>
</xml>

fun template title sidebar body = (
	title' <- return (case title of
		| None => "UMDTalks"
		| Some t => t ^ " - UMDTalks"
	);
	user <- getUser ();
	top <- ( case user of
		| None => return <xml>
				<div class={box}>
					<div class={header}>
						<a link={signin False}>Log in</a>
					</div>
				</div>
			</xml>
		| Some u => return <xml>
				<div class={box}>
					<div class={header}>
						<a link={profile None}>Profile</a> | <a link={signout ()}>Log out</a>
					</div>
				</div>
			</xml>
	);
	return <xml>
		<head>
			<title>{[title']}</title>
			<link rel="stylesheet" type="text/css" href="/css/index.css" />
			<link rel="icon" href="/images/favicon.ico" />
		</head>
		<body>
			<div class={wrapper}>
				<div class={header}>
					<a link={index ()}><img src="/images/reallybigtalkslogo.gif" /></a>
					<div class={login}>
						{top}
					</div>
				</div>
				<div class={content}>
					<div class={left}>
						{sidebar}
					</div>
					<div class={right}>
						{body}
					</div>
				</div>
			</div>
			<div class={footer}>
				<a link={index ()}>Home</a> | (*About | *)University of Maryland &copy; 2011
			</div>
		</body>
	</xml>
)

and index () = (
	search <- searchBox ();
	hasLists <- hasRows (SELECT * FROM lists); (*WHERE lists.Id = 1  ???*)
	featLists <- ( case hasLists of
		| True => queryX (SELECT * FROM lists) (fn r =>
			<xml>
				<div>
					<a link={list r.Lists.Id}>{[r.Lists.Title]}</a>
				</div>
			</xml>
		)
		| False => return <xml>
			There are no featured lists at this time.
		</xml>
	);
	sidebar <- return <xml>
		{search}
		<div class={box}>
			<div class={header}>
				Featured Lists
			</div>
			<div class={content}>
				{featLists}
			</div>
		</div>
	</xml>;
	hasTalks <- hasRows (SELECT * FROM talks);
	featTalks <- ( case hasTalks of
		| True =>
			queryX ( SELECT * FROM talks) (fn r =>
				<xml>
					<div>
						<a link={talk r.Talks.Id}>{[r.Talks.Title]}</a>
					</div>
				</xml>
			)
		| False => return
			<xml>
				There are no featured talks at this time.
			</xml>
		);
	body <- return <xml>
		<div class={box}>
			<div class={header}>
				Featured Talks
			</div>
			<div class={content}>
				{featTalks}
			</div>
		</div>
	</xml>;
	template None sidebar body
)

and list id =
	search <- searchBox ();
	row <- oneOrNoRows (SELECT * FROM lists WHERE lists.Id = {[id]});
	( case row of
		| None =>
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						Sorry!
					</div>
					<div class={content}>
						We could not find the list you were looking for.
					</div>
				</div>
			</xml>;
			template (Some "List not found") search body
		| Some r =>
			sidebar <- return <xml>
				{search}
				<div class={box}>
					<div class={header}>
						Dashboard
					</div>
					<div class={content}>
						Add to list (*<select>
							<option>You have no lists</option>
						</select>*) <br />
						Subscribe to calendar
					</div>
				</div>
				<div class={box}>
					<div class={header}>
						Sublists and Talks
					</div>
					<div class={content}>
						Sublists...
					</div>
				</div>
			</xml>;
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						{[r.Lists.Title]}
					</div>
					<div class={content}>
						Talks in this list
					</div>
				</div>
			</xml>;
			template (Some r.Lists.Title) sidebar body
	)

and talk id =
	search <- searchBox ();
	row <- oneOrNoRows (SELECT * FROM talks WHERE talks.Id = {[id]});
	( case row of
		| None =>
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						Sorry!
					</div>
					<div class={content}>
						We could not find the talk you were looking for.
					</div>
				</div>
			</xml>;
			template (Some "Talk not found") search body
		| Some r => 
			sidebar <- return <xml>
				{search}
				<div class={box}>
					<div class={header}>
						Dashboard
					</div>
					<div class={content}>
						Add to list (*<select>
							<option>You have no lists</option>
						</select>*) <br />
						Download to calendar
					</div>
				</div>
			</xml>;
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						{[r.Talks.Title]}
					</div>
					<div class={content}>
						<div class={title}>Details</div>
						<hr class={hdiv} />
						<ul class={details}>
							<li><img src="/images/user.jpg" /> {[r.Talks.Speaker_name]}</li>
							<li><img src="/images/clock.jpg" /> {[r.Talks.Start_time]}</li>
							<li><img src="/images/house.jpg" /> {[r.Talks.Venue]} </li>
							(*<li>Organizers/Owners: todo!!!</li>*)
						</ul>
						<br />
						<div class={title}>Abstract</div>
						<hr class={hdiv} />
						<div class={abstract}>
							{[r.Talks.Abstract]}
						</div>
					</div>
				</div>
			</xml>;
			template (Some r.Talks.Title) sidebar body
	)

and profile (id : option int) =
	user <- ( case id of
		| None =>
			( getUser ())
		| Some id' =>
			( getUserWithId id')
	);
	search <- searchBox ();
	sidebar <- ( case user of
		| None =>
			return <xml>{search}</xml>
		| Some u =>
			(* Can you do this with one query? *)
			hasLists <- hasRows (SELECT * FROM list_owners, lists WHERE list_owners.Owner_id = {[u.Id]} AND list_owners.List_id = lists.Id);
			userLists <- ( case hasLists of
				| True => queryX (SELECT * FROM list_owners, lists WHERE list_owners.Owner_id = {[u.Id]} AND list_owners.List_id = lists.Id)
					(fn r => 
						<xml>
							<div>
								<a link={list r.Lists.Id}>{[r.Lists.Title]}</a>
							</div>
						</xml>
					)
				| False => return <xml>
					This user has no lists.
				</xml>
			);
			return <xml>
				{search}
				<div class={box}>
					<div class={header}>
						{[u.Alias]}'s Lists
						<a class={button} link={createList ()}>New</a>
					</div>
					<div class={content}>
						{userLists}
					</div>
				</div>
			</xml>
	);
	body <- ( case user of
		| None => 
			return <xml>
				<div class={box}>
					<div class={header}>
						Sorry!
					</div>
					<div class={content}>
						We could not find the user you were looking for.
					</div>
				</div>
			</xml>
		| Some u =>
			hasTalks <- hasRows (SELECT * FROM talk_owners, talks WHERE talk_owners.Owner_id = {[u.Id]} AND talk_owners.Talk_id = talks.Id);
			userTalks <- ( case hasTalks of
				| True => queryX (SELECT * FROM talk_owners, talks WHERE talk_owners.Owner_id = {[u.Id]} AND talk_owners.Talk_id = talks.Id)
					(fn r => 
						<xml>
							<div>
								<a link={talk r.Talks.Id}>{[r.Talks.Title]}</a>
							</div>
						</xml>
					)
				| False => return <xml>
					This user has no talks.
				</xml>
			);
			return <xml>
				<div class={box}>
					<div class={header}>
						{[u.Alias]}'s Profile
						(*<a class={button} link={editAccount INone}>Edit</a>*)
					</div>
					<div class={content}>
						Name: {[u.Alias]}<br />
						Email: {[u.Email]}<br />
						Affiliation: {[u.Affiliation]}<br />
					</div>
				</div>
				<div class={box}>
					<div class={header}>
						{[u.Alias]}'s Talks
						<a class={button} link={createTalk INone}>New</a>
					</div>
					<div class={content}>
						{userTalks}
					</div>
				</div>
			</xml>
	);
	template (Some "Profile") sidebar body

(* TODO: change failed to a record, remembers attempted username(inputError) *)
and signin failed = 
	(* TODO: if already signed in redirect ( url (index ())) *)
	search <- searchBox ();
	msg <- return ( case failed of
		| False => <xml></xml>
		| True => <xml>Invalid username or password.</xml>
	);
	body <- return <xml>
		<div class={box}>
			<div class={header}>
				Login
			</div>
			<div class={content}>	
				{msg}
				<form>
					<p>Username:<br/><textbox{#Username}/><br/>
					Password:<br/><password{#Password}/><br/>
					<submit value="Login" action={authenticate}/>
					</p>
				</form>
				Register <a link={register ()(*INone*)}>here</a>.
			</div>
		</div>
	</xml>;
	template (Some "Login") search body

and signout () =
	cook <- getCookie userSession;
	clearCookie userSession;
	case cook of
		| None =>
			redirect ( url (index ()))
		| Some c =>
			dml (UPDATE users SET Session_crumb = "" WHERE Email={[c.Username]});
			redirect ( url (index ()))

and register error = 
	search <- searchBox ();
	body <- return <xml>
		<div class={box}>
			<div class={header}>
				Register
			</div>
			<div class={content}>	
				<form>
					<p>Email:<textbox{#Email}/><br/>
					Password:<password{#Password}/><br/>
					Name:<textbox{#Alias}/><br/>
					Affiliation:<textbox{#Affiliation}/><br/>
					<submit value="Register" action={createAccount}/>
					</p>
				</form>
			</div>
		</div>
	</xml>;
	template (Some "Register") search body

and createAccount row =
	r <- oneOrNoRows1 (SELECT users.Id FROM users
											WHERE users.Email={[row.Email]});
	case r of
		| Some _ => register ()(*IError "Sorry, this email is already in use."*)
		| None =>
			(* TODO: Some input checking*)
			search <- searchBox ();
			id <- nextval userSeq;
			dml (INSERT INTO users (Id,Email,Alias,Password,Affiliation,Last_login,Image_id,Created_at,Updated_at,Session_crumb) VALUES ({[id]},{[row.Email]},{[row.Alias]},{[Hash.sha512 (row.Email ^ row.Password)]},{[row.Affiliation]},CURRENT_TIMESTAMP,0,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,""));
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						Account created!
					</div>
					<div class={content}>
						Account successfully created. Login <a link={signin False}>here</a>.
					</div>
				</div>
			</xml>;
			template (Some "Account Created") search body

and authenticate row =
	r <- oneOrNoRows1 (SELECT users.Id FROM users
											WHERE users.Email={[row.Username]}
											AND users.Password = {[Hash.sha512 (row.Username ^ row.Password)]});
	case r of
		| None => signin True
		| Some r' =>
			rnd <- Random.str 63;(*use rand?*)
			let
				val session = {Username = row.Username, Session_crumb = rnd}
			in
				dml (UPDATE users SET Session_crumb = {[rnd]} WHERE Email={[row.Username]});
				setCookie userSession {Value = session,
																Expires = None,
																Secure = False};
				redirect ( url (profile None))
			end

and searchBox () : transaction xbody =
	return <xml>
		<div class={box}>
			<div class={header}>
				Find a Talk
			</div>
			<div class={content}>
				<form>
					<textbox{#Query}/>
					<submit action={search} value="Search" />
				</form>
				<a link={unimplemented ()}>Advanced Search</a>
				<p>
				<a link={unimplemented ()}>Upcoming Talks</a><br />
				<a link={unimplemented ()}>Recently Added</a>
				</p>
			</div>
		</div>
	</xml>

and createList () =
	unimplemented ()
	(* user <- getUser ();
	( case user of
		| None => redirect (url (signin False))
		| Some u =>redirect (url (signin False))
	) *)

(* Page to create talks. *)
and createTalk (err : inputError) =
	user <- getUser ();
	( case user of
		| None => redirect (url (signin False))
		| Some u =>
			search <- searchBox ();
			msg <- return ( case err of
				| INone => ""
				| IError s => s
			);
			body <- return <xml>
				<div class={box}>
					<div class={header}>
						Create a new talk
					</div>
					<div class={content}>
						{[msg]}
						<form>
							<p>Title:<textbox{#Title}/><br/>
							Abstract:<textbox{#Abstract}/><br/>
							Speaker:<textbox{#Speaker}/><br/>
							Venue:<textbox{#Venue}/><br/>
							<submit value="Create" action={insertTalk}/>
							</p>
						</form>
					</div>
				</div>
			</xml>;
			template (Some "Create talk") search body
	)

(* Handle user input and insert talk into db. *)
and insertTalk row =
	user <- getUser ();
	( case user of
		| None =>
			redirect (url (signin False))
		| Some u =>
			id <- nextval talkSeq;
			dml (INSERT INTO talks (Id, Title, Abstract, Start_time, End_time, Speaker_name, Venue, Created_at, Updated_at, Image_id) VALUES ({[id]},{[row.Title]},{[row.Abstract]},CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,{[row.Speaker]},{[row.Venue]},CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,0));
			dml (INSERT INTO talk_owners (Owner_id, Talk_id) VALUES ({[u.Id]},{[id]}));
			redirect (url (talk id))
	)

