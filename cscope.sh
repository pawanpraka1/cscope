#!/usr/local/bin/bash
echo "Making tags and cscope database in $PWD ..."

# Deleting the existing cscope.* and tags before makeing fresh.
rm -f cscope.* tags

# Generate Cscope.files 
echo -n Generating list of C, header files ...
find * -name "*.[cshy]" -o -name "*.py" -o -name "*.rs" -o -name "*.sh" -o -name "*.cpp" -o -name "*.toml" -o -name "*.go" -o -name "*.conf" -o -name "*.yaml" -o -name "*.proto" |awk '{printf "%s/%s\n", ENVIRON["PWD"], $1 }' | grep -v 'contrib/' |grep -v 'usr.bin/' | grep -v 'usr.sbin/' | grep -v 'kerberos5/' | grep -v 'rescue/' | grep -v 'sys/sparc64' | grep -v 'sys/pc98' | grep -v 'sys/pci' | grep -v 'sys/pcre' | grep -v 'sys/posix4/' |grep -v 'sys/powerpc/' | grep -v  'sys/ia64' |grep -v 'usr.src/crypto/openssl/ssl' > cscope.files
#find * -name "*.[chy]" -o -name "*.pm" |awk '{printf "%s/%s\n", ENVIRON["PWD"], $1 }' >cscope.files
#find * -name "*.pm" |awk '{printf "%s/%s\n", ENVIRON["PWD"], $1 }' >>cscope.files
echo "done"


# Generate Ctags
echo -n "Generating tags database(this will take a while, please wait) ..."


# Ctags options help
#--extra=[+|.]flags
#	Specifies whether to include extra tag entries for certain kinds of information. The parameter flags is a set of one-letter flags, each representing one kind of extra tag entry to include in the tag file. If flags is preceded by by either the .+. or ... character, the effect of each flag is added to, or removed from, those currently enabled; otherwise the flags replace any current settings. The meaning of each flag is as follows:
#	f : Include an entry for the base file name of every source file (e.g. "example.c"), which addresses the first line of the file.
#	q : Include an extra class-qualified tag entry for each tag which is a member of a class (for languages for which this information is extracted; currently C++, Eiffel, and Java). The actual form of the qualified tag depends upon the language from which the tag was derived (using a form that is most natural for how qualified calls are specified in the language). For C++, it is in the form "class::member"; for Eiffel and Java, it is in the form "class.member". This may allow easier location of a specific tags when multiple occurrences of a tag name occur in the tag file. Note, however, that this could potentially more than double the size of the tag file.
#-B	Use backward searching patterns (?...?).
#-F	Use forward searching patterns (/.../) (the default).
#-L file
#	Read from file a list of file names for which tags should be generated. If file is specified as ".", then file names are read from standard input. File names read using this option are processed following file names appearing on the command line. Options are also accepted in this input. If this option is specified more than once, only the last will apply. Note: file is read in line-oriented mode, where a new line is the only delimiter and non-trailing white space is considered significant, in order that file names containing spaces may be supplied (however, trailing white space is stripped from lines); this can affect how options are parsed if included in the input.

/usr/bin/ctags --extra=+qf -BFL cscope.files
#/usr/bin/ctags --extra=+qf -BFL cscope.files
echo "done"

# Generating Cscope database.
echo -n "Generating cscope database(this will take a while, please wait) ..."

#Cscope options help
#-b	Build the cross-reference only.
#-k	``Kernel  Mode'',  turns  off the use of the default include dir
#	(usually /usr/include) when building the database, since  kernel
#	source trees generally do not use it.
#-q	Enable  fast  symbol  lookup  via an inverted index. This option
#	causes  cscope  to  create   2   more   files   (default   names
#	``cscope.in.out'' and ``cscope.po.out'') in addition to the nor-
#	mal database. This allows a faster symbol search algorithm  that
#	provides   noticeably   faster   lookup  performance  for  large
#	projects.
cscope -bqkR
echo "done"
