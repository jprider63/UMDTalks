table entry : { Id : int, Sd : string}
	PRIMARY KEY Id

style wrapper
style header
style content
style footer

fun main () = return <xml>
	<head>
		<title>UMDTalks</title>
		<link rel="stylesheet" type="text/css" href="/css/index.css" />
	</head>
	<body>
		<div class={wrapper}>
			<div class={header}>
				header...
			</div>
			<div class={content}>
				content!!
			</div>
		</div>
		<div class={footer}>
			About | University of Maryland &copy; 2011
		</div>
	</body>
</xml>
