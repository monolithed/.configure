#! /usr/bin/env sh

css="data/ru/css"

for project in neo septima
	do
		files="${css}/${project}/pages"

		for file in `ls $files`
			do
				file="${files}/${file}"

				if [[ "${file##*.}" == 'scss' ]]
					then
						if [[ $# -eq 0 ]] || [[ $file =~ $1 ]]
							then
								touch --no-create ${file}
								echo "${file} updated!"
						fi
				fi
		done
done

sass --line-comments --line-numbers --watch ${css}

echo && echo -e "CSS files in ${css} directory has been updated already!"
