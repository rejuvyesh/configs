Vim�UnDo� �a�9����,F�.�=A�WW���Ie��N  g   ;; (elpy-enable)   �          $       $   $   $    RjIj    _�                     w        ����                                                                                                                                                                                                                                                                                                                                                             RjHB     �   v   x  g      (require 'ipython)5�_�                    x        ����                                                                                                                                                                                                                                                                                                                                                             RjHE     �   w   y  g      (setq5�_�                    x       ����                                                                                                                                                                                                                                                                                                                                                             RjHH     �   w   y  g      ;(setq5�_�                    y        ����                                                                                                                                                                                                                                                                                                                                                             RjHI     �   x   z  g      # python-shell-interpreter "ipython"5�_�                    z        ����                                                                                                                                                                                                                                                                                                                                                             RjHK     �   y   {  g      ! python-shell-interpreter-args ""5�_�                    {        ����                                                                                                                                                                                                                                                                                                                                                             RjHM     �   z   |  g      / python-shell-prompt-regexp "In \\[[0-9]+\\]: "5�_�                    |        ����                                                                                                                                                                                                                                                                                                                                                             RjHN     �   {   }  g      6 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "5�_�      	              }        ����                                                                                                                                                                                                                                                                                                                                                             RjHP     �   |   ~  g      # python-shell-completion-setup-code5�_�      
           	   ~        ����                                                                                                                                                                                                                                                                                                                                                             RjHS     �   }     g      : "from IPython.core.completerlib import module_completion"5�_�   	              
           ����                                                                                                                                                                                                                                                                                                                                                             RjHU     �   ~   �  g      + python-shell-completion-module-string-code5�_�   
                 �        ����                                                                                                                                                                                                                                                                                                                                                             RjHV     �      �  g      * "';'.join(module_completion('''%s'''))\n"5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             RjHX     �   �   �  g      $ python-shell-completion-string-code5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             RjHZ     �   �   �  g      A "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             RjH^     �   �   �  g      >(autoload 'python-mode "python-mode" "Python editing mode." t)5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             RjHb     �   �   �  g      0(add-hook 'python-mode-hook 'auto-complete-mode)5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             RjHd     �   �   �  g      ((add-hook 'python-mode-hook 'jedi:setup)5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             RjHe     �   �   �  g      ((add-hook 'python-mode-hook 'linum-mode)5�_�                           ����                                                                                                                                                                                                                                                                                                                                                             RjH�    �      g      0 (add-hook 'text-mode-hook 'turn-on-spell-check)5�_�                    w        ����                                                                                                                                                                                                                                                                                                                                                             RjI    �   v   x  g      ;(require 'ipython)5�_�                    w        ����                                                                                                                                                                                                                                                                                                                                                             RjI0    �   v   x  g      (require 'ipython)5�_�                    x        ����                                                                                                                                                                                                                                                                                                                                                             RjIN     �   w   y  g      ;;(setq5�_�                    y        ����                                                                                                                                                                                                                                                                                                                                                             RjIP     �   x   z  g      %;; python-shell-interpreter "ipython"5�_�                    z        ����                                                                                                                                                                                                                                                                                                                                                             RjIQ     �   y   {  g      #;; python-shell-interpreter-args ""5�_�                    {        ����                                                                                                                                                                                                                                                                                                                                                             RjIT     �   z   |  g      1;; python-shell-prompt-regexp "In \\[[0-9]+\\]: "5�_�                    |       ����                                                                                                                                                                                                                                                                                                                                                             RjIW     �   {   }  g      8;; python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "5�_�                    }        ����                                                                                                                                                                                                                                                                                                                                                             RjIX     �   |   ~  g      %;; python-shell-completion-setup-code5�_�                    ~        ����                                                                                                                                                                                                                                                                                                                                                             RjIY     �   }     g      <;; "from IPython.core.completerlib import module_completion"5�_�                            ����                                                                                                                                                                                                                                                                                                                                                             RjIZ     �   ~   �  g      -;; python-shell-completion-module-string-code5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             RjI[     �      �  g      ,;; "';'.join(module_completion('''%s'''))\n"5�_�                    �        ����                                                                                                                                                                                                                                                                                                                                                             RjI\     �   �   �  g      &;; python-shell-completion-string-code5�_�                     �        ����                                                                                                                                                                                                                                                                                                                                                             RjI]     �   �   �  g      C;; "';'.join(get_ipython().Completer.all_completions('''%s'''))\n")5�_�      !               �        ����                                                                                                                                                                                                                                                                                                                                                             RjIb     �   �   �  g      @;;(autoload 'python-mode "python-mode" "Python editing mode." t)5�_�       "           !   �        ����                                                                                                                                                                                                                                                                                                                                                             RjIe     �   �   �  g      2;;(add-hook 'python-mode-hook 'auto-complete-mode)5�_�   !   #           "   �        ����                                                                                                                                                                                                                                                                                                                                                             RjIg     �   �   �  g      *;;(add-hook 'python-mode-hook 'jedi:setup)5�_�   "   $           #   �        ����                                                                                                                                                                                                                                                                                                                                                             RjIh     �   �   �  g      *;;(add-hook 'python-mode-hook 'linum-mode)5�_�   #               $   �        ����                                                                                                                                                                                                                                                                                                                                                             RjIi    �   �   �  g      ;; (elpy-enable)5��