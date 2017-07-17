#!/bin/bash

BASEDIR=$(pwd)
CONFIG_DIR="${BASEDIR}/repositories.d"

for filename in $CONFIG_DIR/*.cnf; do
	if [ -f $filename ]; then
		
		echo "Loading ${filename}..."

		# Reset config
		TARGET_URL=""
		SOURCE_PATH=""
		LFS=0
		GITLAB_LFS_OBJECTS_PATH=""

		cd "${BASEDIR}"

		# Load config file
		source $filename

		if [ -z "${TARGET_URL}" ]; then
			echo "Error! TARGET_URL is not set in the configuration file." 1>&2
			exit 1
		fi

		if [ -z "${SOURCE_PATH}" ]; then
			echo "Error! SOURCE_PATH is not set in the configuration file." 1>&2
			exit 1
		fi

		if [ ! -d "${SOURCE_PATH}" ]; then
			echo "Error! '${SOURCE_PATH}' directory does not exists." 1>&2
			exit 1
		fi

		if [ ! -f "${SOURCE_PATH}/HEAD" ]; then
			echo "Error! '${SOURCE_PATH}' is not a bare git repository." 1>&2
			exit 1
		fi

		echo "Pushing changes to the remote repository..."

		cd "${SOURCE_PATH}"
		git push --all "${TARGET_URL}"
		if [ $? -ne 0 ] ; then
			echo "Error! Command failed." 1>&2
			exit 1
		fi

		echo "Done pushing changes to the remote repository."

		if [ $LFS -eq 1 ] ; then

			if [ ! -z "${GITLAB_LFS_OBJECTS_PATH}" ]; then
				echo "Creating Git LFS compatible links to the GitLab LFS storage..."
				
				for IOD1 in $GITLAB_LFS_OBJECTS_PATH/*; do
					if [ -d "${IOD1}" ]; then

						for IOD2 in $IOD1/*; do
							if [ -d "${IOD2}" ]; then

								for IOD3 in $IOD2/*; do
									if [ -f "${IOD3}" ]; then

										GITLAB_OID_PATH="$GITLAB_LFS_OBJECTS_PATH/${IOD1##*/}/${IOD2##*/}/${IOD3##*/}"
										if [ ! -f "${GITLAB_OID_PATH}" ]; then
											echo "Error! Can not find LFS object file at '${GITLAB_OID_PATH}'." 1>&2
											exit 1
										fi

										LOCAL_OID_DIR="${SOURCE_PATH}/lfs/objects/${IOD1##*/}/${IOD2##*/}"
										mkdir -p "${LOCAL_OID_DIR}"
										if [ $? -ne 0 ] ; then
											echo "Error! Command failed." 1>&2
											exit 1
										fi

										LOCAL_OID_PATH="${LOCAL_OID_DIR}/${IOD1##*/}${IOD2##*/}${IOD3##*/}"
										ln -s -f "${GITLAB_OID_PATH}" "${LOCAL_OID_PATH}"
										if [ $? -ne 0 ] ; then
											echo "Error! Command failed." 1>&2
											exit 1
										fi

									fi
								done
							fi
						done
					fi
				done

			fi
			
			echo "Pushing Git LFS changes..."

			git lfs push --all "${TARGET_URL}"
			if [ $? -ne 0 ] ; then
				echo "Error! Command failed." 1>&2
				exit 1
			fi

			echo "Done pushing Git LFS changes."
		fi
	fi
done

echo "All done."
exit 0
