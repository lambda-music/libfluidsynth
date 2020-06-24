
(if (defined? -DEFINED-LIBFLUIDSYNTH)
    (abort '(aborted 'alread-defined)))

(define -DEFINED-LIBFLUIDSYNTH #t)

(import (lamu lang))
(use "libnewp")

; EXAMPLE
; (define a (start-fluidsynth 'default-sound-font "aaaaa" "local-midi9" "test-server9" "midi")) ;; open the synth
; (apply a '()) ;; close the synth

(define (start-fluidsynth local-id local-port-id remote-id remote-port-id 
                           #!key (sound-font-file "/usr/share/sounds/sf2/FluidR3_GM.sf2" ))
    
  (open-output local-port-id )
  (set! fluidsynth-instance (newp dir: #!current-dir 
                             "fluidsynth"  "--gain=4" 
                             "--midi-driver=jack"
                             ; (string-concatenate (list "--portname=" remote-port-id ) )  ;doesn't work
                             "-o" (string-concatenate (list "audio.jack.id" "=" remote-id  ))
                             "-o" (string-concatenate (list "midi.jack.id" "=" remote-port-id))
                             ; "-o" (string-concatenate (list "midi.portname" "=" remote-port-id )) ;doesn't work
                             "--connect-jack-outputs"
                             sound-font-file ))
  (newp-add fluidsynth-instance)
  (sleep 5000)
  (connect 
   (string-concatenate (list local-id ":" local-port-id ))
   (string-concatenate (list  remote-id ":" remote-port-id )))
  (lambda ()
    (close-output local-port-id)
    (kilp fluidsynth-instance)))
